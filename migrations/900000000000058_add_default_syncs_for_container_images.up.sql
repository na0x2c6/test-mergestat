BEGIN;

--GitHub Org
--Example: SELECT mergestat.add_repo_import('1f337c1a-702c-4411-ab03-25aa43f5a3c1', 'GITHUB_ORG', '{{orgname}}', (array['51c76dcf-05a4-4288-b796-50f74c25f479'])::UUID[])
--GitHub User
--Example: SELECT mergestat.add_repo_import('1f337c1a-702c-4411-ab03-25aa43f5a3c1', 'GITHUB_USER', '{{username}}', (array['51c76dcf-05a4-4288-b796-50f74c25f479'])::UUID[])
--BitBucket owner
--Example: SELECT mergestat.add_repo_import('714d5147-3b35-4dde-a75e-dab527006856', 'owner', '{{ownername}}', (array['51c76dcf-05a4-4288-b796-50f74c25f479'])::UUID[])
--GitLab Groub
--Example: SELECT mergestat.add_repo_import('fc7a3eb7-68b1-4282-a592-acdb1e0bbf91', 'GITLAB_GROUP', '{{groupname}}', (array['51c76dcf-05a4-4288-b796-50f74c25f479'])::UUID[])
--GitLab User
--Example: SELECT mergestat.add_repo_import('fc7a3eb7-68b1-4282-a592-acdb1e0bbf91', 'GITLAB_USER', '{{username}}', (array['51c76dcf-05a4-4288-b796-50f74c25f479'])::UUID[])
CREATE OR REPLACE FUNCTION mergestat.add_repo_import(provider_id UUID, import_type TEXT, import_type_name TEXT, default_container_image_ids UUID[])
RETURNS BOOLEAN
LANGUAGE PLPGSQL VOLATILE
AS $$
DECLARE 
    vendor_type TEXT;
    settings JSONB;
BEGIN
    
    -- get the vendor type
    SELECT vendor
    INTO
    vendor_type
    FROM mergestat.providers
    WHERE id = provider_id;
    
    -- set the settings by vendor
    SELECT 
        CASE
            WHEN vendor_type = 'github'
                THEN jsonb_build_object('type', import_type) || jsonb_build_object('userOrOrg', import_type_name) || jsonb_build_object('defaultContainerImages', default_container_image_ids)
            WHEN vendor_type = 'gitlab'
                THEN jsonb_build_object('type', import_type) || jsonb_build_object('userOrGroup', import_type_name) || jsonb_build_object('defaultContainerImages', default_container_image_ids)
            WHEN vendor_type = 'bitbucket' 
                THEN jsonb_build_object('owner', import_type_name) || jsonb_build_object('defaultContainerImages', default_container_image_ids)
            ELSE '{}'::JSONB
        END 
    INTO
    settings;

    -- add the repo import
    INSERT INTO mergestat.repo_imports (settings, provider) values (settings, provider_id);
    
    RETURN TRUE;
    
END; $$;

--Replace repo import default container images
--Example: SELECT mergestat.update_repo_import_default_container_images('fdebb5e3-17aa-4725-b7c2-b8e47e54df30', (array['51c76dcf-05a4-4288-b796-50f74c25f479', '1dc4ae75-9c93-4f21-8f64-90228b6486e8'])::UUID[])
CREATE OR REPLACE FUNCTION mergestat.update_repo_import_default_container_images(repo_import_id UUID, default_container_image_ids UUID[])
RETURNS BOOLEAN
LANGUAGE PLPGSQL VOLATILE
AS $$
BEGIN
    
    -- update the repo import by replacing the defaultContainerImages element from the settings object
    UPDATE mergestat.repo_imports SET settings = settings - 'defaultContainerImages' || jsonb_build_object('defaultContainerImages', default_container_image_ids)
    WHERE id = repo_import_id;
    
    RETURN TRUE;
    
END; $$;

CREATE OR REPLACE FUNCTION mergestat.enable_container_sync(repo_id_param UUID, container_image_id UUID)
RETURNS BOOLEAN
LANGUAGE PLPGSQL VOLATILE
AS $$
DECLARE
    container_sync_id UUID;
BEGIN

    INSERT INTO mergestat.container_syncs (repo_id, image_id) VALUES (repo_id_param, container_image_id)
        ON CONFLICT (repo_id, image_id) DO UPDATE SET repo_id = EXCLUDED.repo_id, image_id = EXCLUDED.image_id
        RETURNING id INTO container_sync_id;
    
    INSERT INTO mergestat.container_sync_schedules (sync_id) VALUES (container_sync_id) ON CONFLICT DO NOTHING;
    
    PERFORM mergestat.sync_now(container_sync_id);
    
    RETURN TRUE;
    
END; $$;

--Updating the logic to prevent concurrent syncs for the same container sync
CREATE OR REPLACE FUNCTION mergestat.sync_now(container_sync_id UUID)
RETURNS BOOLEAN
LANGUAGE PLPGSQL VOLATILE
AS $$
DECLARE 
    queue_name TEXT;
    queue_concurrency INTEGER;
    queue_priority INTEGER;
    job_id UUID;
    is_sync_already_running BOOLEAN;
BEGIN
    --Check if a sync run is already queued
    WITH sync_running(id, queue, job, status) AS (
        SELECT DISTINCT ON (syncs.id) syncs.id, (image.queue || '-' || repo.provider) AS queue, exec.job_id, job.status,
            CASE WHEN image.queue = 'github' THEN 1 ELSE 0 END AS concurrency
            FROM mergestat.container_syncs syncs
                INNER JOIN mergestat.container_images image ON image.id = syncs.image_id
                INNER JOIN public.repos repo ON repo.id = syncs.repo_id
                LEFT OUTER JOIN mergestat.container_sync_executions exec ON exec.sync_id = syncs.id
                LEFT OUTER JOIN sqlq.jobs job ON job.id = exec.job_id
        WHERE syncs.id = container_sync_id
        ORDER BY syncs.id, exec.created_at DESC
    )
    SELECT CASE WHEN (SELECT COUNT(*) FROM sync_running WHERE status IN ('pending','running')) > 0 THEN TRUE ELSE FALSE END
    INTO is_sync_already_running;
    
    
    IF is_sync_already_running = FALSE
    THEN    
        --Get the queue name
        SELECT DISTINCT (ci.queue || '-' || r.provider)
        INTO queue_name
        FROM mergestat.container_syncs cs
        INNER JOIN mergestat.container_images ci ON ci.id = cs.image_id
        INNER JOIN public.repos r ON r.id = cs.repo_id
        WHERE cs.id = container_sync_id;
        
        --Get the queue concurrency
        SELECT DISTINCT CASE WHEN ci.queue = 'github' THEN 1 ELSE NULL END
        INTO queue_concurrency
        FROM mergestat.container_syncs cs
        INNER JOIN mergestat.container_images ci ON ci.id = cs.image_id
        INNER JOIN public.repos r ON r.id = cs.repo_id
        WHERE cs.id = container_sync_id;

        --Get the queue priority
        SELECT DISTINCT CASE WHEN ci.queue = 'github' THEN 1 ELSE 2 END
        INTO queue_priority
        FROM mergestat.container_syncs cs
        INNER JOIN mergestat.container_images ci ON ci.id = cs.image_id
        INNER JOIN public.repos r ON r.id = cs.repo_id
        WHERE cs.id = container_sync_id;
        
        --Add the queue if missing
        INSERT INTO sqlq.queues (name, concurrency, priority) VALUES (queue_name, queue_concurrency, queue_priority) ON CONFLICT (name) DO UPDATE SET concurrency = excluded.concurrency, priority = excluded.priority;
        
        --Add the job
        INSERT INTO sqlq.jobs (queue, typename, parameters, priority) VALUES (queue_name, 'container/sync', jsonb_build_object('ID', container_sync_id), 0) RETURNING id INTO job_id;
        
        --Add the container sync execution
        INSERT INTO mergestat.container_sync_executions (sync_id, job_id) VALUES (container_sync_id, job_id);
    END IF;
    
    RETURN TRUE;
    
END; $$;

--Delete duplicate container images and add unique constraint
DELETE FROM
mergestat.container_images a
USING mergestat.container_images b
WHERE
    a.id < b.id
    AND a.name = b.name;

ALTER TABLE mergestat.container_images DROP CONSTRAINT IF EXISTS unique_container_images_name;
ALTER TABLE mergestat.container_images ADD CONSTRAINT unique_container_images_name UNIQUE (name);

--Seeding container images
INSERT INTO mergestat.container_images(name, description, type, url, version, queue)
VALUES
('Git Blame', 'Retrieves the git blame of all lines in all files of a git repository', 'docker', 'ghcr.io/mergestat/sync-git-blame', 'latest', 'default'),
('Git Commit Stats', 'Retrieves commit stats for a repo', 'docker', 'ghcr.io/mergestat/sync-git-commit-stats', 'latest', 'default'),
('Git Commits', 'Retrieves the commit history of a repo', 'docker', 'ghcr.io/mergestat/sync-git-commits', 'latest', 'default'),
('Git Files', 'Retrieves files (content and paths) of a git repo', 'docker', 'ghcr.io/mergestat/sync-git-files', 'latest', 'default'),
('Git Refs', 'Retrieves all the refs of a git repo', 'docker', 'ghcr.io/mergestat/sync-git-refs', 'latest', 'default'),
('GitHub Issues', 'Retrieves all the issues of a GitHub repo', 'docker', 'ghcr.io/mergestat/sync-github-issues', 'latest', 'github'),
('GitHub PR Commits', 'Retrieves commits for all pull requests in a GitHub repo', 'docker', 'ghcr.io/mergestat/sync-github-pull-request-commits', 'latest', 'github'),
('GitHub PR Reviews', 'Retrieves the reviews of all pull requests in a GitHub repo', 'docker', 'ghcr.io/mergestat/sync-github-pull-request-reviews', 'latest', 'github'),
('GitHub Pull Requests', 'Retrieves all the pull requests of a GitHub repo', 'docker', 'ghcr.io/mergestat/sync-github-pull-requests', 'latest', 'github'),
('GitHub Repo Info', 'Retrieves info/metadata of a GitHub repo', 'docker', 'ghcr.io/mergestat/sync-github-repo-info', 'latest', 'github'),
('GitHub Stargazers', 'Retrieves all stargazers of a GitHub repo', 'docker', 'ghcr.io/mergestat/sync-github-repo-stargazers', 'latest', 'github'),
('Scan Gitleaks', 'Executes a gitleaks scan on a git repository', 'docker', 'ghcr.io/mergestat/sync-scan-gitleaks', 'latest', 'default'),
('Scan Gosec', 'Executes a gosec scan on a git repository', 'docker', 'ghcr.io/mergestat/sync-scan-gosec', 'latest', 'default'),
('Scan Grype', 'Executes a grype scan on a git repository', 'docker', 'ghcr.io/mergestat/sync-scan-grype', 'latest', 'default'),
('Scan Syft', 'Executes a syft scan on a git repository to generate an SBOM', 'docker', 'ghcr.io/mergestat/sync-scan-syft', 'latest', 'default'),
('Scan Trivy', 'Executes a trivy scan on a git repository', 'docker', 'ghcr.io/mergestat/sync-scan-trivy', 'latest', 'default'),
('Scan Yelp Detect Secrets', 'Executes a Yelp detect-secrets scan on a git repository', 'docker', 'ghcr.io/mergestat/sync-scan-yelp-detect-secrets', 'latest', 'default')
ON CONFLICT DO NOTHING;

--Adding more columns to the response of the function
--https://www.graphile.org/postgraphile/computed-columns/
CREATE OR REPLACE FUNCTION mergestat.container_syncs_latest_sync_runs(container_syncs mergestat.CONTAINER_SYNCS)
RETURNS JSONB
LANGUAGE PLPGSQL STABLE
AS $$
DECLARE
   response JSONB;
BEGIN
    WITH last_completed_syncs AS(
        SELECT
            cs.id AS container_sync_id,
            ci.name AS container_image_name,
            j.id AS job_id,
            j.status,
            j.created_at,
            j.started_at,
            j.completed_at,
            (SELECT COUNT(1) FROM sqlq.job_logs WHERE sqlq.job_logs.job = j.id AND level = 'warn') warning_count,
            (SELECT COUNT(1) FROM sqlq.job_logs WHERE sqlq.job_logs.job = j.id AND level = 'error') error_count
        FROM mergestat.container_syncs cs
        INNER JOIN mergestat.container_sync_executions cse ON cs.id = cse.sync_id
        INNER JOIN mergestat.container_images ci ON cs.image_id = ci.id
        INNER JOIN sqlq.jobs j ON cse.job_id = j.id
        WHERE cs.id = container_syncs.id
        ORDER BY cs.id, j.created_at DESC
        LIMIT 15
    )
    SELECT 
        JSONB_OBJECT_AGG(job_id, TO_JSONB(t) - 'job_id')
    INTO response
    FROM (
        SELECT job_id, created_at, started_at, completed_at, ((EXTRACT('epoch' FROM completed_at)-EXTRACT('epoch' FROM started_at))*1000)::INTEGER AS duration_ms, status FROM last_completed_syncs    
    )t;

    RETURN response;
END; $$;

--Adding more columns to the response of the function
DROP FUNCTION IF EXISTS public.getFilesOlderThan;
CREATE OR REPLACE FUNCTION public.getFilesOlderThan(file_pattern TEXT, older_than_days INTEGER)
RETURNS TABLE (repo TEXT, file_path TEXT, author_when TIMESTAMP(6) WITH TIME ZONE, author_name TEXT, author_email TEXT, hash TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH top_author_when AS (
        SELECT DISTINCT ON (repos.repo, git_commit_stats.file_path) repos.repo, git_commit_stats.file_path, git_commits.author_when, git_commits.author_name, git_commits.author_email, git_commits.hash
        FROM git_commits 
        INNER JOIN repos ON git_commits.repo_id = repos.id 
        INNER JOIN git_commit_stats ON git_commit_stats.repo_id = git_commits.repo_id AND git_commit_stats.commit_hash = git_commits.hash and parents < 2
        WHERE git_commit_stats.file_path LIKE file_pattern
        ORDER BY repos.repo, git_commit_stats.file_path, git_commits.author_when DESC
    )
    SELECT * FROM top_author_when
    WHERE top_author_when.author_when < NOW() - (older_than_days || ' day')::INTERVAL
    ORDER BY top_author_when.author_when DESC;
END
$$;

--Removing reference to schedules
----https://www.graphile.org/postgraphile/custom-queries/
CREATE OR REPLACE FUNCTION mergestat.get_repos_syncs_by_status(repo_id_param UUID, status_param TEXT)
RETURNS JSONB
LANGUAGE PLPGSQL STABLE
AS $$
DECLARE
   response JSONB;
BEGIN
    WITH last_completed_syncs AS(
        SELECT DISTINCT ON (cs.id) 
            cs.id AS container_sync_id,
            ci.name AS container_image_name,
            j.id AS job_id,
            j.status,
            j.completed_at AS sync_last_completed_at,
            (SELECT COUNT(1) FROM sqlq.job_logs WHERE sqlq.job_logs.job = j.id AND level = 'warn') warning_count,
            (SELECT COUNT(1) FROM sqlq.job_logs WHERE sqlq.job_logs.job = j.id AND level = 'error') error_count
        FROM mergestat.container_syncs cs
        INNER JOIN mergestat.container_sync_executions cse ON cs.id = cse.sync_id
        INNER JOIN mergestat.container_images ci ON cs.image_id = ci.id
        INNER JOIN sqlq.jobs j ON cse.job_id = j.id
        WHERE cs.repo_id = repo_id_param AND j.status NOT IN ('pending','running')
        ORDER BY cs.id, j.created_at DESC
    ),
    current_syncs AS(
        SELECT DISTINCT ON (cs.id)
            cs.id AS container_sync_id,
            ci.name AS container_image_name,
            j.id AS job_id,
            j.status,
            j.completed_at AS sync_last_completed_at
        FROM mergestat.container_syncs cs
        LEFT JOIN mergestat.container_sync_executions cse ON cs.id = cse.sync_id
        LEFT JOIN mergestat.container_images ci ON cs.image_id = ci.id
        LEFT JOIN sqlq.jobs j ON cse.job_id = j.id
        WHERE cs.repo_id = repo_id_param AND j.status IN ('pending','running')
        ORDER BY cs.id, j.created_at DESC
    ),
    selected_sync AS(
        SELECT container_sync_id, job_id, container_image_name, sync_last_completed_at, 'running' AS selection FROM current_syncs WHERE status = 'running'
        UNION
        SELECT container_sync_id, job_id, container_image_name, sync_last_completed_at, 'pending' AS selection FROM current_syncs WHERE status = 'pending'
        UNION
        SELECT container_sync_id, job_id, container_image_name, sync_last_completed_at, 'success' AS selection FROM last_completed_syncs WHERE status = 'success'
        UNION
        SELECT container_sync_id, job_id, container_image_name, sync_last_completed_at, 'warning' AS selection FROM last_completed_syncs WHERE warning_count > 0
        UNION
        SELECT container_sync_id, job_id, container_image_name, sync_last_completed_at, 'errored' AS selection FROM last_completed_syncs WHERE status = 'errored' OR error_count > 0
    )
    SELECT 
        JSONB_OBJECT_AGG(job_id, TO_JSONB(t) - 'job_id')
    INTO response
    FROM (
        SELECT container_sync_id, job_id, container_image_name, sync_last_completed_at FROM selected_sync WHERE selection = status_param
    )t;

    RETURN response;
END; $$;

COMMIT;
