import React, { useEffect, useState } from "react";
import { GetData } from "./GetData";

const Q2 = () => {
  const [q2, setq2] = useState([]);

  useEffect(() => {
    const getData = async () => {
      let data = await GetData();
      if (data != null) { 
        setq2(data);
      }
    };
    getData();
  }, []);

  return (
    <>
      <h1
        style={{ textAlign: "center", color: "#007bff", marginBottom: "20px" }}
      >
        API endpoint that returns the details of all matches along with the
        Match Date, Location and total amount of payments made for each match.
      </h1>
      <table
        style={{
          border: "1px solid #ddd",
          width: "80%",
          margin: "auto",
          borderRadius: "10px",
          boxShadow: "0 0 10px rgba(0,0,0,0.1)",
        }}
      >
        <tr
          style={{
            backgroundColor: "#007bff",
            color: "#ffffff",
            padding: "10px",
            borderTopLeftRadius: "10px",
            borderTopRightRadius: "10px",
          }}
        >
          <th>Match Name</th>
          <th>Match Date</th>
          <th>Location</th>
          <th>Amount Paid</th>
        </tr>
        {q2.map((p) => (
          <tr
            key={p.matchID}
            style={{
              backgroundColor: "#ffffff",
              padding: "10px",
              borderBottom: "1px solid #ddd",
            }}
          >
            <th style={{ color: "#333333" }}>{p.matchName}</th>
            <th style={{ color: "#333333" }}>{p.matchDate}</th>
            <th style={{ color: "#333333" }}>{p.location}</th>
            <th style={{ color: "#333333" }}>{p.amt_paid}</th>
          </tr>
        ))}
      </table>
    </>
  );
};

export default Q2;
