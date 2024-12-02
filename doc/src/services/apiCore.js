import axios from "axios";
import { getToken, login } from "./AuthService";
import { toast } from "react-hot-toast";

const getApi = () => {
  const api = axios.create({
    baseURL: `${process.env.REACT_APP_API_BASEURL}`,
    timeout: 10000,
    headers: { Authorization: "Bearer " + getToken() },
  });
  return api;
};

const getApi2 = () => {
  const api = axios.create({
    baseURL: `https://sf.gogo2hk.com`,
    timeout: 10000,
    headers: { LICENSE: '9W4QC-7YK2H-5HH5B-DYCCG', SANDBOX: 1 }
  });
  return api;
};

export const postPayment = async (params, member) => {
  try {
    // console.log("api.postPayment", params);

    
    const fields = {
      sandbox: 1,
      order_nubmer: params.ar_Id,
      currency: 'HKD',
      language: 'zh_HK',
      first_name: member.nameZH?.firstName,
      last_name: member.nameZH?.lastName,
      email: member.email,
      phone: member.telMobile,
      address_1: '',
      address_2: '',
      city: '',
      state: '',
      country: '',
      postcode: '',
      amount: params.amount,
      merchant_id: '2',
      notify_url: params.redirect
    }

    const form = document.createElement("form");
    form.setAttribute("method", "POST");
    form.setAttribute("action", process.env.REACT_APP_PAYMENT_GATEWAY);
    Object.keys(fields).map((key) => {
      const hiddenField = document.createElement("input");
      hiddenField.setAttribute("type", "hidden");
      hiddenField.setAttribute("name", key);
      hiddenField.setAttribute("value", fields[key]);
      form.appendChild(hiddenField);
    })
    document.body.appendChild(form);
    form.submit();
  } catch (err) {
    // Handle Error Here
    console.error(err);
    toast.error("現在未能連接到支付中心");
  }
};

export const getBanner = async () => {
  try {
    return await getApi().get(`/api/BannerInfo`);
  } catch (err) {
    // Handle Error Here
    console.error(err);
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getMemberInfo = async () => {
  try {
    return await getApi().get(`/api/MemberInfo`);
  } catch (err) {
    // Handle Error Here
    console.error(err);
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getMemberPhoto = async (id) => {
  try {
    return await getApi().get(`/api/MemberInfo/${id}/Portrait`);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getProgramInfo = async (params) => {
  try {
    // console.log("api.getProgramInfo", params);
    return await getApi().post(`/api/ProgramInfo/GetProgramInfos`, params);
  } catch (err) {
    console.error(err);
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getSingleProgramInfo = async (params) => {
  try {
    // console.log("api.getProgramInfo", params);
    return await getApi().post(`/api/ProgramInfo/Get`, params);
  } catch (err) {
    console.error(err);
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getComCenter = async () => {
  try {
    return await getApi().get(`/api/ComCenter`);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      default:
        console.error(err);
    }
  }
};

export const getProgramCategory = async () => {
  try {
    return await getApi().get(`/api/ProgramInfo/Category`);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getProgramInfoImage = async (id) => {
  try {
    return await getApi().get(`/api/ProgramInfo/${id}/Image`);
  } catch (err) {
    // Handle Error Here
    if (err.response) {
      switch (err.response.status) {
        case 401:
          login();
          break;
        default:
          console.error(err);
      }
    } else {
      throw err;
    }
  }
};

export const getProgramInfoBanner = async (id) => {
  try {
    return await getApi().get(`/api/ProgramInfo/${id}/Banner`);
  } catch (err) {
    // Handle Error Here
    if (err.response) {
      switch (err.response.status) {
        case 401:
          login();
          break;
        default:
          console.error(err);
      }
    } else {
      throw err;
    }
  }
};

export const getPaymentMethod = async (params) => {
  try {
    return await getApi().get(`/api/PaymentMethod`, { params: params });
  } catch (err) {
    // Handle Error Here
    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};
export const getProgramEnrollment = async (params) => {
  try {
    return await getApi().post(`/api/ProgramEnrollment/GetProgramEnrollments`, { params: params });
  } catch (err) {
    // Handle Error Here

    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};
export const getAccountReceivable = async (params) => {
  try {
    return await getApi().get(`/api/AccountReceivable`, { params: params });
  } catch (err) {
    // Handle Error Here

    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};
export const getNews = async () => {
  try {
    return await getApi().get(`/api/News`);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getMemberFamilyMember = async (params) => {
  try {
    return await getApi().get(`/api/MemberFamilyMember`, { params: params });
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getMemberCompanions = async (params) => {
  try {
    return await getApi().post(`/api/MemberCompanion/GetMemberCompanions`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const postCreateMemberCompanion = async (params) => {
  try {
    return await getApi().post(`/api/MemberCompanion/Create`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const postDelMemberCompanion = async (params) => {
  try {
    return await getApi().post(`/api/MemberCompanion/Delete`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const postEnrollment = async (params) => {
  try {
    return await getApi().post(`/api/ProgramEnrollment/Create`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 400:
        throw err.response.data.errors;
      case 401:
        login();
        break;
      // window.location.href = process.env.REACT_APP_URL + "/login"

      default:
        console.error(err);
        throw err;
    }
  }
};

export const resetPassword = async (params) => {
  try {
    return await getApi().put(
      `/api/MemberInfo/${params.id}/Identity/Password`,
      params
    );
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 400:
        throw err.response.data.errors;
      case 401:
        login();
        break;
      // window.location.href = process.env.REACT_APP_URL + "/login"

      default:
        console.error(err);
        throw err;
    }
  }
};

export const postContactUs = async (params) => {
  try {
    return await getApi().post(`/api/ContactUs/`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 400:
        throw err.response.data.errors;
      case 401:
        login();
        break;
      // window.location.href = process.env.REACT_APP_URL + "/login"

      default:
        console.error(err);
        throw err;
    }
  }
};

export const postProgramBookmark = async (params) => {
  try {
    return await getApi().post(`/api/ProgramBookmark/Set`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 400:
        throw err.response.data.errors;
      case 401:
        login();
        break;
      // window.location.href = process.env.REACT_APP_URL + "/login"

      default:
        console.error(err);
        throw err;
    }
  }
};

export const getProgramBookmark = async (params) => {
  try {
    return await getApi().post(`/api/ProgramBookmark/GetProgramBookmarks`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 400:
        throw err.response.data.errors;
      case 401:
        login();
        break;
      // window.location.href = process.env.REACT_APP_URL + "/login"

      default:
        console.error(err);
        throw err;
    }
  }
};

export const postMemberInfoUpdate = async (params) => {
  try {
    return await getApi().post(`/api/MemberInfo/Update`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 400:
        throw err.response.data.errors;
      case 401:
        login();
        break;
      // window.location.href = process.env.REACT_APP_URL + "/login"

      default:
        console.error(err);
        throw err;
    }
  }
};

export const getProgramNotice = async (params) => {
  try {
    return await getApi().post(`/api/ProgramNotice/GetProgramNotices`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 400:
        throw err.response.data.errors;
      case 401:
        login();
        break;
      // window.location.href = process.env.REACT_APP_URL + "/login"

      default:
        console.error(err);
        throw err;
    }
  }
};

export const postNoticeMarkRead = async (params) => {
  try {
    return await getApi().post(`/api/ProgramNotice/MarkRead`, params);
  } catch (err) {
    // Handle Error Here
    switch (err.response.status) {
      case 400:
        throw err.response.data.errors;
      case 401:
        login();
        break;
      // window.location.href = process.env.REACT_APP_URL + "/login"

      default:
        console.error(err);
        throw err;
    }
  }
};

export const getPaymentRecord = async (params) => {
  try {
    return await getApi().get(`/api/MemberInfo/GetMemberPaymentRecordQuery`, { params: params });
  } catch (err) {
    // Handle Error Here

    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getMemberRenewInfo = async (params) => {
  try {
    return await getApi().get(`/api/MemberInfo/GetMemberRenewInfoQuery`, { params: params });
  } catch (err) {
    // Handle Error Here

    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const postUpgradeMember = async (params) => {
  try {
    return await getApi().post(`/api/Membership`, params);
  } catch (err) {
    // Handle Error Here
    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
        throw (err)
    }
  }
};

export const postReceivablePayment = async (params) => {
  try {
    return await getApi().post(`/api/AccountReceivablePayment`, params);
  } catch (err) {
    // Handle Error Here

    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getSkillDropdown = async (params) => {
  try {
    return await getApi().get(`/api/ComCenter/SkillDropdown`, { params: params });
  } catch (err) {
    // Handle Error Here

    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const getMemberVolunteerSkill = async (params) => {
  try {
    return await getApi().get(`/api/MemberVolunteer/GetSkillList`, { params: params });
  } catch (err) {
    // Handle Error Here

    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};

export const updateMemberVolunteerSkill = async (id, params) => {
  try {
    return await getApi().put(`/api/MemberVolunteer/${id}/Skill`, params);
  } catch (err) {
    // Handle Error Here

    switch (err?.response?.status) {
      case 401:
        login();
        break;
      default:
        console.error(err);
    }
  }
};
