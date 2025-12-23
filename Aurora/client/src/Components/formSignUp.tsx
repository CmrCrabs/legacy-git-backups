import React from 'react';
import { useState } from 'react';
const FormSignUp = () => {
    const [data , setdata] = useState(["","","",""])
    async function handleSignUp(x : React.FormEvent){
        x.preventDefault()
        console.log(x)
        
    }
    return (
        <div className="signup">
            <form onSubmit={Event => {handleSignUp(Event)}}>
                <input type="text" name='Username'  placeholder='Username'/> <br />
                <input type="text" name='email'  placeholder='email'/> <br /> 
                <input type="text" name='password'  placeholder='password'/> <br /> 
                <button type="submit">Submit</button>
            </form>
        </div>
    );
}
 
export default FormSignUp;