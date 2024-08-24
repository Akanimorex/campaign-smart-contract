import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const LockModule = buildModule("LockModule", (m) => {
  

  const bank = m.contract("Bank");

  return { bank };
});

export default LockModule;
