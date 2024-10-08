import axios from "axios";
import Swal from "sweetalert2";
const apiURL = "https://localhost:5001/api";

const CategoryHook = {
  GetAllCategory: async () => {
    try {
      const response = await axios.get(`${apiURL}/Categories`);
      return response.data;
    } catch (error) {
      //console.error(`Can't create account! ${error}`);
      return error;
    }
  },

  CreateCategory: async (category) => {
    try {
      //const data = JSON.stringify(category);
      const response = await axios.post(`${apiURL}/Categories`, category);
      return response.data;
    } catch (error) {
      //console.error(`Can't create account! ${error}`);
      return error;
    }
  },

  EditCategory: async (id, category) => {
    try {
      //const data = JSON.stringify(category);
      const response = await axios.put(`${apiURL}/Categories/${id}`, category);
      return response.data;
    } catch (error) {
      //console.error(`Can't create account! ${error}`);
      return error;
    }
  },

  DeleteCategory: async (id) => {
    try {
      const response = await axios.delete(`${apiURL}/Categories/${id}`);
      return response.data;
    } catch (error) {
      console.error(`Can't delete category! ${error}`);
      Swal.fire("Error", error.response.data.message, "error");
    }
  },
  GetCategoryById: async (id) => {
    try {
      //const data = JSON.stringify(category);
      const response = await axios.get(`${apiURL}/Categories/${id}`);
      return response.data;
    } catch (error) {
      //console.error(`Can't create account! ${error}`);
      return error;
    }
  },
};

export default CategoryHook;