import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';

const AppModule = buildModule('AppModule', m => {
  const id = m.contract('App');
  return { id };
});

export default AppModule;
