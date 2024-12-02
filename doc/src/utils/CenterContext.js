import React from "react"

const CenterContext = React.createContext({
    center: null,
    setCenter: (ctr) => {}
})

export default CenterContext

