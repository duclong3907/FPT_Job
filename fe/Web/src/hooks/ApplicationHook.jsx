import axios from "axios";
import Swal from "sweetalert2";
const apiURL = "https://localhost:5001/api";

const ApplicationHook = {
  GetAllApplications: async () => {
    try {
      const response = await axios.get(`${apiURL}/Application`);
      return response.data;
    } catch (error) {
      alert(`Can't get all application! ${error}`);
    }
  },

  CreateApplication: async (application) => {
    try {
      const response = await axios.post(`${apiURL}/Application`, application);
      Swal.fire("Success", response.data.message, "success");
    } catch (error) {
      Swal.fire("Error", error.response.data.message, "error");
    }
  },

  EditApplication: async (id, application) => {
    try {
      const response = await axios.put(
        `${apiURL}/Application/${id}`,
        application
      );
      return response.data;
    } catch (error) {
      alert(`Can't edit application! ${error}`);
    }
  },

  DeleteApplication: async (id) => {
    try {
      const response = await axios.delete(`${apiURL}/Application/${id}`);
      return response.data;
    } catch (error) {
      alert(`Can't delete application! ${error}`);
    }
  },

  GetApplicationById: async (id) => {
    try {
      const response = await axios.get(`${apiURL}/Application/${id}`);
      return response.data;
    } catch (error) {
      alert(`Can't get application detail! ${error}`);
    }
  },
};

export default ApplicationHook;
