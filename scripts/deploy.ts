import { ethers } from "hardhat";

async function main() {
  const TestOne = await ethers.deployContract('Bank');

  await TestOne.waitForDeployment();

  console.log('contract deployed at ' + TestOne.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
