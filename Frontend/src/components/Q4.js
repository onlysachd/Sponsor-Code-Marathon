import React, { useEffect, useState } from "react";
import { GetDataQ4 } from "./GetDatQ4";

const Q4 = () => {


  const [q4, setq4] = useState([]);
  const [year, setYear] = useState("");
  const [input, setInput] = useState("");

  useEffect(() => {
    const getDataQ4 = async () => {
      let data = await GetDataQ4(year);
      if (Array.isArray(data)) {
        setq4(data);
      } else {
        console.error("Invalid response from GetDataQ4");
      }
    };
    getDataQ4();
  }, [year]); // Changed input to year

  const onChange = (e) => {
    setInput(e.target.value);
  };

  const onSubmit = (e) => {
    e.preventDefault();
    setYear(input);
  };

  return (
    <div className="container mt-5">
      <h1 className="text-center">
        Develop an API endpoint that returns the list of sponsors and the number
        of matches they have sponsored in a specific year, which is provided as
        a query parameter.
      </h1>
      <form className="form-group" onSubmit={onSubmit}>
        <div className="form-group">
          <label htmlFor="year">Year:</label>
          <input
            type="text"
            className="form-control"
            id="year"
            value={input}
            onChange={onChange}
          />
        </div>
        <button type="submit" className="btn btn-primary">
          Get detail
        </button>
      </form>
      <h3 className="text-center mt-3">
        Sponsors and the number of matches they have sponsored in {year}
      </h3>
      <table className="table table-striped table-bordered mt-3">
        <thead>
          <tr>
            <th>Sponsor Name</th>
            <th>Number of matches they sponsored</th>
          </tr>
        </thead>
        <tbody>
          {q4.map((p) => (
            <tr key={p.sponsorname}>
              <td>{p.sponsorname}</td>
              <td>{p.numberOfspons}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Q4;
