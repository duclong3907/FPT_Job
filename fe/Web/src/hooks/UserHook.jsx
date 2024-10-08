import axios from "axios";
import Swal from "sweetalert2";
const apiURL = "https://localhost:5001/api";

const UserHook = {
  GetAllUsers: async () => {
    try {
      const response = await axios.get(`${apiURL}/User`);
      return response.data;
    } catch (error) {
      console.error(`Can't get all account! ${error}`);
      //return error;
    }
  },

  CreateUser: async (user) => {
    try {
      //const data = JSON.stringify(category);
      const response = await axios.post(`${apiURL}/User`, user);
      return response.data;
      // Swal.fire("Success", response.data.message, "success");
    } catch (error) {
      // console.error(`Can't create account! ${error}`);
      Swal.fire("Error", error.response.data.message, "error");

      //return error;
    }
  },

  EditUser: async (id, user) => {
    try {
      const response = await axios.put(`${apiURL}/User/${id}`, user);
      Swal.fire("Success", response.data.message, "success");
      // return response.data;
    } catch (error) {
      Swal.fire("Error", error.response.data.message, "error");
    }
  },

  DeleteUser: async (id) => {
    try {
      //const data = JSON.stringify(category);
      const response = await axios.delete(`${apiURL}/User/${id}`);
      return response.data;
    } catch (error) {
      console.error(`Can't delete user! ${error}`);
      //return error;
    }
  },
  GetUserById: async (id) => {
    try {
      //const data = JSON.stringify(category);
      const response = await axios.get(`${apiURL}/User/${id}`);
      return response.data;
    } catch (error) {
      console.error(`Can't get user! ${error}`);
      //return error;
    }
  },
  GetUser2FAStatus: async (id) => {
    try {
      const response = await axios.get(`https://localhost:5001/api/Home/${id}`);
      return response.data;
    } catch (e) {
      console.error(`Cant get user two factor status! ${e}`);
    }
  },
  SetUser2FAStatus: async (id, status) => {
    try {
      const response = await axios.put(
        `https://localhost:5001/api/Home/Check2FA/${id}`,
        status
      );
      return response.data;
    } catch (e) {
      console.error(`Cant set user two factor status! ${e}`);
    }
  },
};

export default UserHook;
