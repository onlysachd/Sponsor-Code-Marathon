import "bootstrap/dist/css/bootstrap.css";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import "./App.css";
import Banner from "./components/Banner";
import Q2 from "./components/Q2";
import Q3 from "./components/Q3";
import Navigation from "./components/Navigation";
import Post from "./components/Post";
import Q4 from "./components/Q4";

function App() {
  return (
    <>
      <BrowserRouter>
        <Navigation />
        <Routes>
          <Route path="/" element={<Banner />} />
          <Route path="/q2" element={<Q2 />} />
          <Route path="/q3" element={<Q3 />} />
          <Route path="/post" element={<Post LoggedIn />} />
          <Route path="/q4" element={<Q4 />} />
        </Routes>
      </BrowserRouter>
    </>
  );
}

export default App;
