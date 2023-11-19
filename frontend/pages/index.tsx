
import Header from '@/components/Header';
import Dashboard from './Dashboard';


export default function Home() {
  return (
    <main >
      <div className='flex flex-col items-center justify-center py-12 '>
  
   <Header />
   <Dashboard />
      </div>
    </main>
  )
}