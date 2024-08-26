import { Link } from "react-router-dom";

export default function Navigation() {
  return (
    <nav
      style={{
        backgroundColor: "#f0f0f0",
        padding: "10px",
        display: "flex",
        justifyContent: "space-between",
      }}
    >
      <Link
        to="/"
        style={{ margin: "0 10px", textDecoration: "none", color: "#000" }}
      >
        Home
      </Link>
      <Link
        to="/Post"
        style={{ margin: "0 10px", textDecoration: "none", color: "#000" }}
      >
        Add Payment
      </Link>
      <Link
        to="/q2"
        style={{ margin: "0 10px", textDecoration: "none", color: "#000" }}
      >
        Question 2
      </Link>
      <Link
        to="/q3"
        style={{ margin: "0 10px", textDecoration: "none", color: "#000" }}
      >
        Question 3
      </Link>
      <Link
        to="/q4"
        style={{ margin: "0 10px", textDecoration: "none", color: "#000" }}
      >
        Question 4
      </Link>
    </nav>
  );
}
