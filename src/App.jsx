import { useState, useEffect } from 'react'
import reactLogo from '/react.svg'
import githubLogo from '/github.svg'
import viteLogo from '/vite.svg'
import './styles/App.css'
import {format} from 'date-fns'

function App() {
  const [currentDateTime, setCurrentDateTime] = useState(new Date());
  const [formatDate, setFormatDate] = useState('dd/mm/yyyy');
  useEffect(() => {
    // Actualizar la fecha y hora cada segundo
    const intervalId = setInterval(() => {
      setCurrentDateTime(new Date());
      setFormatDate(format(new Date(), 'dd/MM/yyyy'));
    }, 1000);
    
    // Limpieza del intervalo al desmontar el componente
    return () => clearInterval(intervalId);
  }, []);

  return (
    <>
      <div>
        <a href='https://github.com/Camran1234/SA-P1.git' target='_blank'>
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href='https://github.com/Camran1234/SA-P1.git' target='_blank'>
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
        <a href='https://github.com/Camran1234/SA-P1.git' target='_blank'>
          <img src={githubLogo} className="logo github" alt="Github logo" />
        </a>
        
      </div>
      <h1>Jonathan Marcos Valiente González</h1>
      <h2>201931581</h2>
      <div>
        <h3>{formatDate}</h3>
        <p>{currentDateTime.toLocaleTimeString()}</p>
      </div>
      <p className="read-the-docs">
        App hecha con Vite y template de React
      </p>
    </>
  )
}

export default App
