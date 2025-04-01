import './App.css';
import Header from './components/Header';
import 'components/Count';
function App() {
  return (
    <div>
      <h1>Hello, React!</h1>
      <Header />
      <p>Welcome to my first React app.</p>
    </div>
    <Count />
  );
}
export default App;
