
import { gql } from '@apollo/client'

const ADD_CREDENTIAL = gql`
  mutation addToken($provider: UUID!, $token: String!, $type: String!, $username: String = "") {
    addToken(provider: $provider, token: $token, type: $type, username: $username)
  }
`

const REMOVE_CREDENTIAL = gql`
  mutation deleteCredential($id: UUID!) {
    deleteServiceAuthCredential(input: {id: $id}) {
      deletedServiceAuthCredentialNodeId
    }
  }
`

export { ADD_CREDENTIAL, REMOVE_CREDENTIAL }
