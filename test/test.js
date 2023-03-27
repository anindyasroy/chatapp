const { ethers } = require("hardhat");
const { assert, expect } = require("chai");

describe("myToken", () => {
  let myTokenFactory, myToken;
  beforeEach(async () => {
    myTokenFactory = await ethers.getContractFactory("MyToken");
    myToken = await myTokenFactory.deploy();
  });
  it("check price", async () => {
    const priceValue = await myToken.price();
    const expectedValue = 1000000000000000;
    assert.equal(priceValue.toString(), expectedValue.toString());
  });
});
