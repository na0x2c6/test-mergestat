import React, { useState } from 'react'
import {
  Button,
  Checkbox,
  Dropdown,
  Filter,
  Input,
  Menu,
  Modal,
} from '@mergestat/blocks'
import { PlusIcon, SearchIcon, XIcon } from '@mergestat/icons'
import { TagListFilterModal } from '../modals'


type TagsListDropDownProps = {
  trigger: JSX.Element
}
export const TagsListDropDown: React.FC<TagsListDropDownProps> = (props) => {

  const [tags, setTags] = useState(allTags)
  const [modalOpen, setModalOpen] = useState(false)
  const handleCheck = (checked: boolean, index: number) => {
    setTags(prev => prev.map((tag, i) => {
      return i != index ? tag : { ...tag, checked: !checked }
    }))
  }
  const handleSearch = (text: string) => {
    const startPoint = 2
    if (!text || text.length < startPoint) {
      setTags(allTags)
      return
    }
    setTags(prev => prev.filter(t => t.title.includes(text)))
  }

  return (
    <Dropdown
      overlay={() => (
        <Menu className=" relative z-50 rounded w-80 p-4 flex flex-col gap-y-4 ">
          <h4 className=" font-semibold">Tags</h4>
          <label className="relative">
            <SearchIcon className="t-icon absolute left-2 text-gray-400" />
            <Input onChange={(e: any) => handleSearch(e.target.value)} placeholder="Search..." className="pl-8" />
          </label>
          {tags.slice(0,7).map((tag, index) => (
            <div key={index} className=" flex items-center gap-x-3 text-sm">
              <Checkbox
                checked={tag.checked}
                onClick={() => handleCheck(tag.checked, index)}
                onChange={(e) => {
                  const checked = e.currentTarget.checked
                }}
              />
              <span>{tag.title}</span>
            </div>
          ))}
          <span className=' text-blue-600 font-medium cursor-pointer' onClick={() => setModalOpen(true)}>
            Show more
          </span>
          <TagListFilterModal
            tags={tags}
            open={modalOpen}
            onClose={() => setModalOpen(false)}
            handleCheck={handleCheck}
            handleSearch={handleSearch}
          />
          <Menu.Divider />
          <Button className=" w-full flex justify-center">Filter</Button>
        </Menu>
      )}
      trigger={props.trigger}
    />
  )
}

const allTags = [
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
  { title: 'javascript', checked: true },
  { title: 'node', checked: false },
  { title: 'dom', checked: true },
  { title: 'c++', checked: false },
]