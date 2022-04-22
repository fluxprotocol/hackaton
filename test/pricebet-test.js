const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");



describe("PriceBet", function () {
  before(async function () {
    this.signers = {};

    const signers = await ethers.getSigners();
    this.signers.oracleAdmin = signers[0];
    this.signers.alice = signers[1];
    this.signers.bob = signers[2];
  });
  beforeEach(async function () {
    const priceFeedArtifact = await artifacts.readArtifact("FluxPriceFeed");
    const gameArtifact = await artifacts.readArtifact("Game");
    this.priceFeed = await waffle.deployContract(this.signers.oracleAdmin, priceFeedArtifact, [this.signers.oracleAdmin.address, 8, "ethprice"]);
    this.game = await waffle.deployContract(this.signers.oracleAdmin, gameArtifact, [this.priceFeed.address]);
  })
  
  it("should increment users points if they are correct", async function () {
    expect(await this.priceFeed.connect(this.signers.oracleAdmin).latestAnswer()).to.equal(0);
    await this.priceFeed.connect(this.signers.oracleAdmin).transmit(10);
    expect(await this.priceFeed.connect(this.signers.oracleAdmin).latestAnswer()).to.equal(10);

    // Alice votes UP
    await this.game.connect(this.signers.alice).vote(true);

    // Bob votes DOWN
    await this.game.connect(this.signers.bob).vote(false);

    // Oracle updates to 11
    expect(await this.priceFeed.connect(this.signers.oracleAdmin).latestAnswer()).to.equal(10);
    await this.priceFeed.connect(this.signers.oracleAdmin).transmit(11);
    expect(await this.priceFeed.connect(this.signers.oracleAdmin).latestAnswer()).to.equal(11);

    await this.game.connect(this.signers.bob).tally();

    expect(await this.game.connect(this.signers.bob).getPoints(this.signers.alice.address)).to.equal(1);
    expect(await this.game.connect(this.signers.bob).getPoints(this.signers.bob.address)).to.equal(0);

  });
});
