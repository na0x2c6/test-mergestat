import { gql } from '@apollo/client'

const ADD_CONTAINER_IMAGE = gql`
  mutation addContainerImage($name: String!, $url: String!, $version: String!, $queue: String) {
    createContainerImage(
      input: {containerImage: {name: $name, url: $url, version: $version, queue: $queue}}
    ) {
      containerImage {
        id
        name
      }
    }
  }
`

const UPDATE_CONTAINER_IMAGE = gql`
  mutation updateContainerImage($id: UUID!, $name: String, $description: String, $url: String, $version: String, $parameters: JSON) {
    updateContainerImage(
      input: {patch: {name: $name, description: $description, url: $url, version: $version, parameters: $parameters}, id: $id}
    ) {
      containerImage {
        id
        name
        description
        url
        version
        parameters
      }
    }
  }
`

const REMOVE_CONTAINER_IMAGE = gql`
  mutation removeContainerImage($id: UUID!) {
    deleteContainerImage(input: {id: $id}) {
      deletedContainerImageNodeId
    }
  }
`

export { ADD_CONTAINER_IMAGE, UPDATE_CONTAINER_IMAGE, REMOVE_CONTAINER_IMAGE }
