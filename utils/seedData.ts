import { geohashForLocation } from 'geofire-common';

export interface Hangout {
  id: string;
  title: string;
  description: string;
  category: string;
  location: {
    lat: number;
    lng: number;
    geohash: string;
  };
  startTime: string;
  endTime: string;
  hostId: string;
  participants: string[];
  capacity: number;
  meetingPoint?: string;
}

export const SEEDED_HANGOUTS: Hangout[] = [
  {
    id: '1',
    title: 'Chai + Walk at Cubbon Park',
    description: 'A casual stroll with some refreshing tea.',
    category: 'Social',
    location: {
      lat: 12.9757,
      lng: 77.5929,
      geohash: geohashForLocation([12.9757, 77.5929]),
    },
    startTime: new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString(),
    endTime: new Date(Date.now() + 4 * 60 * 60 * 1000).toISOString(),
    hostId: 'host_1',
    participants: ['user_1', 'user_2'],
    capacity: 10,
    meetingPoint: 'Gate 2, Cubbon Park',
  },
  {
    id: '2',
    title: 'Board Games at Third Wave',
    description: 'Playing Catan and drinking coffee.',
    category: 'Gaming',
    location: {
      lat: 12.9345,
      lng: 77.6101,
      geohash: geohashForLocation([12.9345, 77.6101]),
    },
    startTime: new Date(Date.now() + 5 * 60 * 60 * 1000).toISOString(),
    endTime: new Date(Date.now() + 8 * 60 * 60 * 1000).toISOString(),
    hostId: 'host_2',
    participants: [],
    capacity: 6,
    meetingPoint: 'Corner table near the window',
  },
  {
    id: '3',
    title: 'Street Photography Loop',
    description: 'Exploring the vibrant streets of Indiranagar.',
    category: 'Creative',
    location: {
      lat: 12.9719,
      lng: 77.6412,
      geohash: geohashForLocation([12.9719, 77.6412]),
    },
    startTime: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
    endTime: new Date(Date.now() + 27 * 60 * 60 * 1000).toISOString(),
    hostId: 'host_3',
    participants: ['user_4'],
    capacity: 5,
    meetingPoint: 'Indiranagar Metro Station',
  },
];
