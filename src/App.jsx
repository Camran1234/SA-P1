import { useState, useEffect } from 'react'
import reactLogo from '/react.svg'
import githubLogo from '/github.svg'
import viteLogo from '/vite.svg'
import './styles/App.css'
import {format} from 'date-fns'

function App() {
  const [currentDateTime, setCurrentDateTime] = useState('HH:mm:ss #M');
  const [formatDate, setFormatDate] = useState('dd/mm/yyyy');
  useEffect(() => {
    // Actualizar la fecha y hora cada segundo
    const intervalId = setInterval(() => {
      const date = new Date().toLocaleString('en-US', { timeZone: 'America/Guatemala' });
      const time = new Date().toLocaleTimeString('en-US', { timeZone: 'America/Guatemala' });
      setCurrentDateTime(time);
      setFormatDate(format(date, 'dd/MM/yyyy'));
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
        <p>{currentDateTime}</p>
      </div>
      <p className="read-the-docs">
        App hecha con Vite y template de React
      </p>
    </>
  )
}

export default App
