export default class Town extends Phaser.Scene {
  private gold: number;
  private wood: number;
  private ore: number;
  private army: any[];

  constructor() {
    super({ key: 'town' });

    this.gold = 0;
    this.wood = 0;
    this.ore = 0;
    this.army = [];
  }
}
