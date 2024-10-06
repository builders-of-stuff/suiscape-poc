import Phaser from 'phaser';
import { Barracks } from '$lib/game-objects/buildings.svelte';
import BarracksPng from '$lib/assets/barracks.png';

export default class Town extends Phaser.Scene {
  private gold: number;
  private wood: number;
  private ore: number;
  private army: any[];
  // private buildings: any;
  private barracks: any;
  private generator: any;

  private width: number;
  private height: number;
  private centerWidth: number;
  private centerHeight: number;

  constructor() {
    super({ key: 'town' });

    this.gold = 0;
    this.wood = 0;
    this.ore = 0;
    this.army = [];
  }

  preload() {
    this.load.spritesheet('barracks', BarracksPng, {
      frameWidth: 128,
      frameHeight: 128
    });
  }

  create() {
    this.width = this.scale.gameSize.width;
    this.height = this.scale.gameSize.height;
    this.centerWidth = Number(this.width) / 2;
    this.centerHeight = Number(this.height) / 2;

    this.cameras.main.setBackgroundColor(0x87ceeb);

    // this.buildings = this.add.group();
    // this.generator = new Generator(this);
    this.barracks = new Barracks(this, this.centerWidth, this.centerHeight);
  }

  update() {}
}
