// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import React from 'react'
import ReactDOM from 'react-dom'
import fetch from 'isomorphic-fetch'
import { polyfill } from 'es6-promise';
import socket from './socket'

class Panel extends React.Component {
  constructor(props) {
    super(props)
  }

  checkStatus(response) {
    debugger
    if (response.status >= 200 && response.status < 300) {
      return response;
    } else {
      var error = new Error(response.statusText);
      error.response = response;
      throw error;
    }
  }

parseJSON(response) {
  return response.json();
}

  // reduxify
  httpPost(url, data) {
    const headers = {
      Authorization: localStorage.getItem('phoenixAuthToken'),
      Accept: 'application/json',
      'Content-Type': 'application/json',
    }

    const body = JSON.stringify(data);
    return fetch(url, {
      method: 'post',
      headers: headers,
      body: body,
    })
    .then(this.checkStatus)
    .then(this.parseJSON);
  }

  onSubmit() {
    const data = {
      username: this.refs.username.value,
      email: this.refs.email.value,
      password: this.refs.password.value,
      password_confirmation: this.refs.passwordConfirmation.value,
    }
    this.httpPost('/registrations', {user: data})
    .then((data) => {
      localStorage.setItem('phoenixAuthToken', data.jwt)
      //
      // dispatch({
      //   type: Constants.CURRENT_USER,
      //   currentUser: data.user,
      // });
      //
      // dispatch(pushPath('/'));
    })
    .catch((error) => {
      error.response.json()
      .then((errorJSON) => {
        // dispatch({
        //   type: Constants.REGISTRATIONS_ERROR,
        //   errors: errorJSON.errors,
        // });
      });
    });
  }

  render() {
    return (
      <div>
        <form onSubmit={() => this.onSubmit()}>
          <div className="field">
            <input ref="username" type="text" placeholder="Username" required={true} />
          </div>
          <div className="field">
            <input ref="email" type="email" placeholder="Email" required={true} />
          </div>
          <div className="field">
            <input ref="password" type="password" placeholder="Password" required={true} />
          </div>
          <div className="field">
            <input ref="passwordConfirmation" type="password" placeholder="Confirm password" required={true} />
          </div>
          <button type="submit">Sign up</button>
        </form>
        <a href="/sign_in">Sign in</a>
      </div>
    )
  }
}

ReactDOM.render(
  <Panel/>,
  document.getElementById('content')
)
