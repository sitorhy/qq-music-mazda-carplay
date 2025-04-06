import { Tag, TagGroup } from '../model/tag';

const tagGroups: TagGroup[] = [
  {
    tagGroupId: 0x66,
    tagGroupName: '场景',
    icon: '',
  },
  {
    tagGroupId: 0x67,
    tagGroupName: '心情',
    icon: '',
  },
  {
    tagGroupId: 0x68,
    tagGroupName: '语种',
    icon: '',
  }
];

const tagGroupsMap: Map<number, Tag[]> = new Map();
tagGroupsMap.set(0x66, [
  {
    tagId: 0x88,
    tagName: '运动'
  },
  {
    tagId: 0x89,
    tagName: '学习工作'
  },
  {
    tagId: 0x90,
    tagName: '婚礼'
  },
  {
    tagId: 0x91,
    tagName: '约会'
  },
  {
    tagId: 0x92,
    tagName: '校园'
  },
  {
    tagId: 0x93,
    tagName: '驾驶'
  },
  {
    tagId: 0x94,
    tagName: '旅行'
  },
]);

tagGroupsMap.set(0x67, [
  {
    tagId: 0x101,
    tagName: '英语'
  },
  {
    tagId: 0x102,
    tagName: '日语'
  }
]);

tagGroupsMap.set(0x68, [
  {
    tagId: 0x201,
    tagName: '伤感'
  },
  {
    tagId: 0x202,
    tagName: '快乐'
  },
  {
    tagId: 0x203,
    tagName: '安静'
  },
  {
    tagId: 0x204,
    tagName: '励志'
  },
  {
    tagId: 0x205,
    tagName: '治愈'
  },
]);

export async function getAllTagGroups() {
  return Promise.resolve(tagGroups);
}

export async function getTagsByGroupId(groupId: number): Promise<Tag[]> {
  return Promise.resolve(tagGroupsMap.get(groupId) || []);
}