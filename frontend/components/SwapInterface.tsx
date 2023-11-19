import { useState } from 'react';
import { useAccount, useBalance, useContractWrite } from 'wagmi';
import { SECURE_DEX_ABI, SECURE_DEX_ADDRESS } from '@/lib/constants';

const SwapInterface = () => {
  const { address } = useAccount();
  const { data: balanceData } = useBalance({
    address: address,
    watch: true,
  });
  const { write: swapTokens } = useContractWrite({
    address: SECURE_DEX_ADDRESS,
    abi: SECURE_DEX_ABI,
    functionName: 'swap', // Placeholder for the actual function name
  });

  const [payAmount, setPayAmount] = useState('');
  const [receiveAmount, setReceiveAmount] = useState('');

  const handleSwap = () => {
    // Call the swap function from your contract
    // This is just a placeholder function call, replace with actual logic
    swapTokens({ args: [payAmount, receiveAmount] });
  };

  return (
    <div className="bg-black p-6 max-w-md mx-auto rounded-xl shadow-lg flex flex-col items-center">
      <div className="flex justify-between items-center w-full mb-4">
        <button className="text-white font-bold py-2 px-4 rounded">Swap</button>
      </div>
      <div className="flex flex-col w-full mb-4">
        <label className="text-white mb-2">You pay</label>
        <input
          type="number"
          value={payAmount}
          onChange={(e) => setPayAmount(e.target.value)}
          placeholder="0"
          className="input input-bordered input-primary w-full mb-2"
        />
        <label className="text-white mb-2">You receive</label>
        <input
          type="number"
          value={receiveAmount}
          onChange={(e) => setReceiveAmount(e.target.value)}
          placeholder="0"
          className="input input-bordered input-primary w-full"
        />
      </div>
      <div className="flex flex-col w-full">
        <button
          className="btn btn-primary w-full mb-4"
          onClick={handleSwap}
        >
          Select token
        </button>
        <div className="text-white text-sm">
          <span>Balance: {balanceData?.formatted} MATIC</span>
        </div>
        <div className="text-white text-sm mt-4">
          Polygon Mumbai token bridge
          <br />
          Deposit tokens to the Polygon Mumbai network.
        </div>
      </div>
    </div>
  );
};

export default SwapInterface;
