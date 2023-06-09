import { ColoredBox, Stat } from '@mergestat/blocks'
import { AutoImportIcon, RepositoryIcon } from '@mergestat/icons'
import { MetricNumber } from 'src/views/shared/metric-number'

type GitSourceStatsProps = {
  loading: boolean
  totalAuto: number
  totalManual: number
  totalRepos: number
}

const GitSourceStats: React.FC<GitSourceStatsProps> = ({ loading, totalAuto, totalManual, totalRepos }: GitSourceStatsProps) => {
  return (
    <div className='md_grid md_grid-cols-3 gap-6 space-y-4 md_space-y-0 mb-6'>
      <Stat className='shadow-sm w-full'>
        <Stat.Left>
          <Stat.Label>Total repos</Stat.Label>
          <Stat.Number>
            <MetricNumber loading={loading} metric={totalRepos || 0} />
          </Stat.Number>
        </Stat.Left>
        <Stat.Right>
          <ColoredBox size='12'><RepositoryIcon className='t-icon t-icon-default' /></ColoredBox>
        </Stat.Right>
      </Stat>
      <Stat className='shadow-sm w-full'>
        <Stat.Left>
          <Stat.Label>Repos from auto imports</Stat.Label>
          <Stat.Number>
            <MetricNumber loading={loading} metric={totalAuto || 0} />
          </Stat.Number>
        </Stat.Left>
        <Stat.Right>
          <ColoredBox size='12'><AutoImportIcon className='t-icon t-icon-default' /></ColoredBox>
        </Stat.Right>
      </Stat>
      <Stat className='shadow-sm w-full'>
        <Stat.Left>
          <Stat.Label>Repos added manually</Stat.Label>
          <Stat.Number>
            <MetricNumber loading={loading} metric={totalManual || 0} />
          </Stat.Number>
        </Stat.Left>
        <Stat.Right>
          <ColoredBox size='12'><RepositoryIcon className='t-icon t-icon-default' /></ColoredBox>
        </Stat.Right>
      </Stat>
    </div>
  )
}

export default GitSourceStats
