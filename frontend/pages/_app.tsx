import '@/styles/globals.css'
import type { AppProps } from 'next/app'
import { createWeb3Modal, defaultWagmiConfig } from '@web3modal/wagmi/react'
import { WagmiConfig } from 'wagmi'
import { polygonMumbai } from 'wagmi/chains'

const projectId = process.env.NEXT_PUBLIC_PROJECT_ID;


const chains = [polygonMumbai]

const metadata = {
  name: 'secureDEX',
  description: 'oracle protected swaps',
  url: '',
  icons: ['']
}


const wagmiConfig = defaultWagmiConfig({ chains, projectId, metadata })
createWeb3Modal({ wagmiConfig, projectId, chains })

export default function App({ Component, pageProps }: AppProps) {
  return (
    <WagmiConfig config={wagmiConfig}>
      <div className='px-5'>
    
      <Component {...pageProps} />
      </div>
    </WagmiConfig>
  )
}