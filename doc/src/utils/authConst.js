export const IDENTITY_CONFIG = {
    authority: process.env.REACT_APP_AUTH_URL,
    client_id: process.env.REACT_APP_CLIENT_ID,
    response_type: "code",
    scope: "profile openid ELCSS4S_mobile_api",
    redirect_uri: `${process.env.REACT_APP_URL}/login-callback/`,
    post_logout_redirect_uri: `${process.env.REACT_APP_URL}/logout-callback/`,
    automaticSilentRenew: true,
    silent_redirect_uri: `${process.env.REACT_APP_URL}/silent-callback/`
    
};

export const METADATA_OIDC = {
    issuer: process.env.REACT_APP_AUTH_URL,
    jwks_uri: process.env.REACT_APP_AUTH_URL + "/.well-known/openid-configuration/jwks",
    authorization_endpoint: process.env.REACT_APP_AUTH_URL + "/connect/authorize",
    token_endpoint: process.env.REACT_APP_AUTH_URL + "/connect/token",
    userinfo_endpoint: process.env.REACT_APP_AUTH_URL + "/connect/userinfo",
    end_session_endpoint: process.env.REACT_APP_AUTH_URL + "/connect/endsession",
    check_session_iframe: process.env.REACT_APP_AUTH_URL + "/connect/checksession",
    revocation_endpoint: process.env.REACT_APP_AUTH_URL + "/connect/revocation",
    introspection_endpoint: process.env.REACT_APP_AUTH_URL + "/connect/introspect"
};