import axios from "axios";

async function GetDataQ4(year) {
  const url = `http://localhost:5297/api/employee/matches-count?year=${year}`;
  let data = null;
  try {
    let response = await axios.get(url);
    if (response.data !== null) {
      data = await response.data;
      console.log("Data from api" + JSON.stringify(data));
    }
  } catch (error) {
    return JSON.stringify(error);
  }
  return data;
}

export { GetDataQ4 };
