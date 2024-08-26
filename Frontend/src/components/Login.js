import React from 'react'
import { useContext } from 'react'
import { LogContext } from '../store/store'

const Login = () => {
    const log = useContext(LogContext)
  return (
    <h1>Login</h1>
  )
}

export default Login