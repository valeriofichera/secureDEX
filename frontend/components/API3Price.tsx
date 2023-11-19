import { useEffect, useState } from 'react';
import { SECURE_DEX_ABI, SECURE_DEX_ADDRESS } from '@/lib/constants';
import { useContractRead } from 'wagmi';
import { Wallet_Icon } from './icons/Wallet_Icon';

const API3Price = () => {


  const {data: value, isLoading} = useContractRead({
    address: SECURE_DEX_ADDRESS,
    abi: SECURE_DEX_ABI,
    functionName: 'readvalueFeed',
  });

  console.log(value);

  // Use a state to hold the formatted balance to prevent content mismatch
  const [valueFormatted, setValueFormatted] = useState('Loading...');



  useEffect(() => {
    // Update the balance when the value is loaded
    if (value && !isLoading) {
      setValueFormatted(`${value} provided w/ API3`);
    }

    if (value && !isLoading) {
      setValueFormatted(value.toString());
    }
  }, [value, isLoading]);

  return (
    <div className="grid grid-cols-1 gap-2 p-5 bg-slate-200 rounded-sm font-nebula">
      
      <h2 className="col-span-1 text-xl font-bold text-black">
      <p>Token Balance</p>
      </h2>

      <div className='grid col-span-1'>
      <div className="flex flex-row gap-5">
        <Wallet_Icon className="h-[100px]" />
        <h2 className="text-center text-4xl font-bold text-black">
          {valueFormatted}
        </h2>
      </div>
      </div>

      <h2 className="col-span-1 text-xl font-bold text-black">
      <p>my Deposits</p>
      </h2>

      <div className='grid col-span-1'>
      <div className="flex flex-row gap-5">
        <Wallet_Icon className="h-[100px]" />
        <h2 className="text-center text-4xl font-bold text-black">
          {valueFormatted}
        </h2>
      </div>
      </div>
 
    </div>
  );
};

export default API3Price;
