import React from "react"

const MemberContext = React.createContext({
    member: null,
    setMember: (member) => {}
})

export default MemberContext