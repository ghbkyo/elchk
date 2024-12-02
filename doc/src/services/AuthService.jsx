import { IDENTITY_CONFIG, METADATA_OIDC } from "../utils/authConst";
import { UserManager, WebStorageStateStore } from "oidc-client-ts";
import base64 from 'base-64'

export const isBrowser = typeof window !== "undefined"

export const mgr = isBrowser ? new UserManager({
    ...IDENTITY_CONFIG,
    userStore: new WebStorageStateStore({ store: window.sessionStorage }),
    metadata: METADATA_OIDC,
}) : null

export const getUser = () => {
    const user = sessionStorage.getItem(
        `oidc.user:${process.env.REACT_APP_AUTH_URL}:${process.env.REACT_APP_CLIENT_ID}`
    )

    return user
}

export const getToken = () => {
    return getUser() ? JSON.parse(getUser()).access_token : null
}

export const getProfile = () => {
    const userJson = getUser()
    if (userJson) return JSON.parse(userJson).profile
    return userJson
}

export const loginRedirect = (url) => {
    const redirect_url = url ? url : process.env.REACT_APP_URL
    mgr.signinRedirect({state: redirect_url})
}

export const login = (username, password) => {
    window.location.href = '/login'
}

export const doLogin = (username, password) => {
    return new Promise((resolve, reject) => {
        fetch(process.env.REACT_APP_AUTH_URL + '/connect/token', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                Authorization: `Basic ${base64.encode(process.env.REACT_APP_CLIENT_ID + ':')}`,
            },
            body: 'grant_type=password&username=' + username + '&password=' + password,
        })
        .then(res => res.json())
        .then(result => {
            if (result['error']) {
                reject(result);
            } else {
                sessionStorage.setItem(
                    `oidc.user:${process.env.REACT_APP_AUTH_URL}:${process.env.REACT_APP_CLIENT_ID}`, JSON.stringify(result))
                resolve(result);
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

export const loginSilentCallback = () => {
    try {
        mgr.signinSilentCallback()
    } catch (err) {
        logout()
    }
 }

export const isLoggedIn = (path) => {
    if (
        ["/logout-callback/", "/login-callback/", "/silent-callback/"].includes(
          path
        )
      )
    return true
    
    const storage = getUser()
    const user = JSON.parse(storage)
    return !!user && !!user.access_token
}

export const getMemberStorage = () => {
    return !!sessionStorage.getItem("member") ? sessionStorage.getItem("member") : null
}

export const getCenterStorage = () => {
    return !!sessionStorage.getItem("center") ? sessionStorage.getItem("center") : null
}

export const getUserimgStorage = () => {
    return !!sessionStorage.getItem("userImg") ? sessionStorage.getItem("userImg") : null
}

export const loginCallback = async () => {
    const result = await mgr.signinRedirectCallback()
    return result
}

export const logout = () => {
    sessionStorage.removeItem("member")
    sessionStorage.removeItem("center")
    sessionStorage.removeItem("userImg")
    sessionStorage.removeItem(`oidc.user:${process.env.REACT_APP_AUTH_URL}:${process.env.REACT_APP_CLIENT_ID}`)
    window.location.href = '/'
}

export const logoutRedirect = () => {
    mgr.signoutRedirectCallback()
  }
