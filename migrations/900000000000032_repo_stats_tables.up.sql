BEGIN;


ALTER TABLE public.github_repo_info
ADD COLUMN advanced_security text;

ALTER TABLE public.github_repo_info
ADD COLUMN secret_scanning text;

ALTER TABLE public.github_repo_info
ADD COLUMN secret_scanning_push_protection text;

ALTER TABLE public.github_repo_info
DROP COLUMN IF EXISTS is_mirror;

ALTER TABLE public.github_repo_info
ADD COLUMN mirror_url text;

ALTER TABLE public.github_repo_info
RENAME COLUMN disk_usage TO size;

ALTER TABLE public.github_repo_info
DROP COLUMN IF EXISTS open_graph_image_url;

ALTER TABLE public.github_repo_info
DROP COLUMN IF EXISTS license_nickname;

COMMENT ON COLUMN public.github_repo_info.advanced_security IS 'advanced security availability';
COMMENT ON COLUMN public.github_repo_info.secret_scanning IS 'secret scanning availability';
COMMENT ON COLUMN public.github_repo_info.secret_scanning_push_protection IS 'secret scanning push protection availability';

COMMIT;
