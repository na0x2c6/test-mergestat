import { faker } from '@faker-js/faker'
import { GetRepoImportsQuery } from 'src/api-logic/graphql/generated/schema'
import { GET_REPO_IMPORTS } from 'src/api-logic/graphql/queries/get-repo-imports'

export const mockImportsData: GetRepoImportsQuery = {
  repoImports: {
    totalCount: 4,
    nodes: [
      {
        id: faker.datatype.uuid(),
        type: 'GITHUB_USER',
        settings: {
          user: 'jhcanonn'
        },
        lastImport: null
      },
      {
        id: faker.datatype.uuid(),
        type: 'GITHUB_USER',
        settings: {
          user: 'gdcanonn'
        },
        lastImport: faker.date.recent(9),
      },
      {
        id: faker.datatype.uuid(),
        type: 'GITHUB_ORG',
        settings: {
          org: 'mergestat'
        },
        lastImport: faker.date.recent(9),
      },
      {
        id: faker.datatype.uuid(),
        type: 'GITHUB_ORG',
        settings: {
          org: 'mergestat'
        },
        lastImport: faker.date.recent(9),
      },
    ]
  }
}

export const apolloMockImports = {
  request: {
    query: GET_REPO_IMPORTS
  },
  result: {
    data: mockImportsData
  }
}
