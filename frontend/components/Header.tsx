import React from "react";

import { Logo } from "./icons/Logo";
import Link from "next/link";

function Header() {
  return (
    <div className="min-w-screen flex items-center mt-5 font-nebula font-bold p-5">

      <Link href="/" className="flex items-center justify-start flex-grow">
        <Logo className="h-[100px]" />
      </Link>

      <div className="flex flex-row gap-10 justify-center">
      
      </div>

      <div className="flex items-center justify-end flex-grow">
        <w3m-button label="Connect Wallet" balance="show" />
      </div>
    </div>
  );
}

export default Header;
