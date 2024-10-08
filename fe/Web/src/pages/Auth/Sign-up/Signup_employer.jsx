import React, { useState } from "react";
import Swal from "sweetalert2";
import useAuth from "../../../hooks/authHook";
// import Loading from "../../Share/Loading";

const SignupEmployeer = ({ registerHandler }) => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [companyName, setCompanyName] = useState("");
  const { signup } = useAuth();

  const signupBtn = async (e) => {
    e.preventDefault();
    signup(name, email, phone, companyName, password, confirmPassword, "Employer");
  };

  const handleGoogleLogin = (event) => {
    event.preventDefault();
    window.location.assign('https://localhost:5001/api/Auth/LoginGoogle?role=Employer');
  };
  const handleFacebookLogin = (event) => {
    event.preventDefault();
    // window.location.assign('https://localhost:5001/api/Auth/signin-facebook?role=Employer');
    Swal.fire('Info', 'This function is currently under maintenance!', 'info');
  }

  return (
    <div className="row">
      <div className="col-md-6 col-sm-12 col-12 login-main-left">
        <img src="./assets/home/img/banner-login.png" />
      </div>

      <div className="col-md-6 col-sm-12 col-12 login-main-right">
        <form className="login-form reg-form">
          <div className="login-main-header">
            <h3>Register for a Employer Account</h3>
          </div>
          <div className="reg-info">
            <h3>Account</h3>
          </div>
          <div className="input-div one">
            <div className="div lg-lable">
              <input
                type="text"
                className="input form-control-lgin"
                value={email}
                placeholder="Email"
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
          </div>
          <div className="input-div one">
            <div className="div lg-lable">
              <input
                type="password"
                className="input form-control-lgin"
                value={password}
                placeholder="Password"
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>
          </div>
          <div className="input-div one">
            <div className="div lg-lable">
              <input
                type="password"
                className="input form-control-lgin"
                value={confirmPassword}
                placeholder="Confirm Password"
                onChange={(e) => setConfirmPassword(e.target.value)}
              />
            </div>
          </div>
          <div className="input-div one">
            <div className="div lg-lable">
              <input
                type="text"
                className="input form-control-lgin"
                value={name}
                placeholder="Contact person name"
                onChange={(e) => setName(e.target.value)}
              />
            </div>
          </div>
          <div className="input-div one">
            <div className="div lg-lable">
              <input
                type="text"
                className="input form-control-lgin"
                value={phone}
                placeholder="Phone number"
                onChange={(e) => setPhone(e.target.value)}
              />
            </div>
          </div>
          <div className="input-div one">
            <div className="div lg-lable">
              <input
                type="text"
                className="input form-control-lgin"
                value={companyName}
                placeholder="Company name"
                onChange={(e) => setCompanyName(e.target.value)}
              />
            </div>
          </div>
          <div className="form-group d-block frm-text">
            <a href="#" className="fg-login d-inline-block"></a>
            <a href="/signin" className="fg-login float-right d-inline-block">
              Do you already have an account? Log in
            </a>
          </div>
          <button
            type="submit"
            className="btn btn-primary float-right btn-login d-block w-100"
            onClick={signupBtn}
          >
            Employer Registration
          </button>
          <div className="form-group d-block w-100 mt-5">
            <div className="text-or text-center">
              <span>Or</span>
            </div>

            <div className="row">
              <div className="col-sm-6 col-12 pr-7">
                <button className="btn btn-secondary btn-login-facebook btnw w-100 float-left"
                  onClick={handleFacebookLogin}>
                  <i className="fa fa-facebook" aria-hidden="true"></i>
                  <span> Login with Facebook</span>
                </button>
              </div>
              <div className="col-sm-6 col-12 pl-7">
                <button
                  className="btn btn-secondary btn-login-google btnw w-100 float-left"
                  onClick={handleGoogleLogin}
                >
                  <i className="fa fa-google" aria-hidden="true"></i>
                  <span> Login with Google</span>
                </button>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
};

export default SignupEmployeer;
