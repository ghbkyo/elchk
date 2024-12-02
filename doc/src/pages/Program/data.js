const timeslotOptions = [
    {
        value: "Morning",
        label: '上午(09:00-14:00)',
    },
    {
        value: "Afternoon",
        label: '下午(14:00-18:00)',
    },
    {
        value: "Evening",
        label: '晚上(18:00-22:00)',
    },
];

const dayOfWeekOptions = [
    {
        value: "Monday",
        label: '星期一',
    },
    {
        value: "Tuesday",
        label: '星期二',
    },
    {
        value: "Wednesday",
        label: '星期三',
    },
    {
        value: "Thursday",
        label: '星期四',
    },
    {
        value: "Friday",
        label: '星期五',
    },
    {
        value: "Saturday",
        label: '星期六',
    },
    {
        value: "Sunday",
        label: '星期日',
    },
];

const targetOptions = [
    {
        value: '幼童(6歲以下)',
        label: '幼童(6歲以下)',
    },
    {
        value: '兒童(6-12歲)',
        label: '兒童(6-12歲)',
    },
    {
        value: '青少年(12歲以上)',
        label: '青少年(12歲以上)',
    },
    {
        value: '婦女',
        label: '婦女',
    },
    {
        value: '家長',
        label: '家長',
    },
    {
        value: '親子',
        label: '親子',
    },
    {
        value: '長者',
        label: '長者',
    },
    {
        value: '義工',
        label: '義工',
    },
];

const feeOptions = [
    {
        value: 1,
        label: '免費',
        limit: [0, 0]
    },
    {
        value: 2,
        label: '$20或以下',
        limit: [0, 20]
    },
    {
        value: 3,
        label: '$50或以下',
        limit: [0, 50]
    },
    {
        value: 4,
        label: '$100或以下',
        limit: [0, 100]
    },
    {
        value: 5,
        label: '$100以上',
        limit: [100, 99999999]
    },
];

export { timeslotOptions, dayOfWeekOptions, targetOptions, feeOptions };