import { Typography } from '@mergestat/blocks'
import Link from 'next/link'
import { useRouter } from 'next/router'
import React from 'react'
import { repSyncState } from 'src/views/@types'


type RepositoryDataProps = {
    name: string
    brief?: string
    syncStatus:repSyncState
}
export const RepositoryData: React.FC<RepositoryDataProps> = (props) => {
    const router=useRouter()
    const {repoName}=router.query
    console.log("trying to get repo name "+repoName);
    
    return (
        <div>
            <Link href={`/repos/${repoName}/${props.name}?repSyncState=${props.syncStatus}`}>
                <Typography.Title className=" cursor-pointer hover_text-blue-600">
                    {props.name}
                </Typography.Title>
            </Link>

            <Typography.Text size="sm" className=' text-gray-500' >
                {props.brief}
            </Typography.Text>
        </div>
    )
}
