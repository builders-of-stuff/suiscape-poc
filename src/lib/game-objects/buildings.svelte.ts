import { sharedState } from '$lib/shared/shared.state.svelte';

export class Barracks extends Phaser.GameObjects.Sprite {
  constructor(scene, x, y, name = 'barracks') {
    super(scene, x, y, name);

    this.scene = scene;
    this.name = name;

    scene.add.existing(this);
    this.init();
  }

  init() {
    // this.scene.anims.create({
    //   key: this.name,
    //   frames: this.scene.anims.generateFrameNumbers(this.name, { start: 0, end: 0 }),
    //   frameRate: 1
    // });

    const sprite = this.scene.add.sprite(this.x, this.y, 'barracks');
    sprite.setScale(2);

    const glowSprite = this.scene.add.sprite(this.x, this.y, 'barracks');
    glowSprite.setScale(2.1);
    glowSprite.setTint(0xffff00);
    glowSprite.setAlpha(0);

    sprite.setInteractive();
    sprite.on('pointerover', () => {
      glowSprite.setAlpha(1);
    });
    sprite.on('pointerout', () => {
      glowSprite.setAlpha(0);
    });

    sprite.on('pointerdown', () => {
      sharedState.setDialogOpen(true);
      // Check if a menu is already open
      // if (!this.menu) {
      //   this.menu = this.showMenu();
      // } else {
      //   // If a menu is already open, close it
      //   this.menu.destroy();
      //   this.menu = null;
      // }
    });
  }

  showMenu() {
    // Create a menu container
    const menu = this.scene.add.container(this.x, this.y - 100);

    // Add a background for the menu
    const bg = this.scene.add.rectangle(0, 0, 200, 150, 0x000000, 0.8);
    menu.add(bg);

    // Add some text or buttons to the menu
    const text = this.scene.add.text(0, -50, 'Building Menu', {
      fontSize: '20px',
      fill: '#fff'
    });
    text.setOrigin(0.5);
    menu.add(text);

    // Add a close button
    const closeButton = this.scene.add.text(80, -65, 'X', {
      fontSize: '20px',
      fill: '#fff'
    });
    closeButton.setInteractive();
    closeButton.on('pointerdown', () => {
      menu.destroy();
    });
    menu.add(closeButton);

    // You can add more menu items here

    return menu;
  }
}
