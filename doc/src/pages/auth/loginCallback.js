import React, { useEffect } from "react";
import { mgr, logout } from "../../services/AuthService";
import { getMemberInfo, getMemberPhoto} from '../../services/apiCore';

const LoginCallback = () => {
    useEffect(() => {
        getToken()
    })

    const getToken = async () => {
        try {
            const result = await mgr.signinRedirectCallback()
            const userResult = await getMemberInfo()
            const userImg = await getMemberPhoto(userResult.data[0].id)
            sessionStorage.setItem("member", JSON.stringify(userResult.data[0]))
            sessionStorage.setItem("center",  JSON.stringify(userResult.data[0].center))
            sessionStorage.setItem("userImg",  userImg.data)
            
            const url = new URL(result.state)
            window.location.replace(url.pathname)
        } catch (err) {
            console.error(err)
            window.alert("登入發生錯誤, 請重新登入帳戶")
            logout()
        }
    }
    return <div> Signing in</div>
}
      
export default LoginCallback