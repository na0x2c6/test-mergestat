import { Checkbox, Panel, Table, Typography } from '@mergestat/blocks'
import React from 'react'
import { columns } from './columns'

import { sampleDatatypesettingsData } from './sample-data'

export const SettingsTable: React.FC = (props) => {
    // TODO: export this logic to a hook
    const processedData = sampleDatatypesettingsData.map((item, index) => ({
        checked: <Checkbox checked={item.checked} />,
        column: item.column,
        type: item.type
    }))
    return (
        <Panel>
            <Panel.Header>
                <Typography.Title>
                    Ttable with data
                </Typography.Title>
            </Panel.Header>
            <Panel.Body className='p-0'>

                <Table
                    scrollY={'100%'}
                    responsive
                    borderless
                    noWrapHeaders
                    className="overflow-visible relative z-0"
                    columns={columns}
                    dataSource={processedData}
                />
            </Panel.Body>
        </Panel>


    )
}

