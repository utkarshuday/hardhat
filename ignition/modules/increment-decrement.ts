import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';

const IDModule = buildModule('IDModule', m => {
  const id = m.contract('IncrementDecrement');

  return { id };
});

export default IDModule;
