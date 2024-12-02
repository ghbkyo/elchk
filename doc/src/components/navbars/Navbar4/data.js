const notifications = [
    {
        icon: 'user-plus',
        variant: 'primary',
        text: 'New User Registered',
        time: '2 min ago',
    },
    {
        icon: 'message-square',
        variant: 'orange',
        text: 'A new comment on your post',
        time: '3 min ago',
    },
    {
        icon: 'paperclip',
        variant: 'success',
        text: 'A new message from',
        time: '10 min ago',
    },
    {
        icon: 'heart',
        variant: 'danger',
        text: 'A new like on your comment',
        time: '14 min ago',
    },
];

const profileOptions = [
    {
        icon: 'user',
        label: '個人資料',
        redirectTo: '/other/account/home',
    },
    {
        icon: 'repeat',
        label: '轉換中心',
        redirectTo: '/other/account/home',
    },
    {
        icon: 'unlock',
        label: '登出',
        redirectTo: '/logout',
    },
];

export { notifications, profileOptions };
