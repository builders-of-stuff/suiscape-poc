<script lang="ts">
  import Phaser from 'phaser';
  import * as Menubar from '$lib/components/ui/menubar';

  import { onMount } from 'svelte';

  const gameConfig = {
    type: Phaser.AUTO,
    scale: {
      mode: Phaser.Scale.RESIZE,
      parent: 'game-container',
      width: '100%',
      height: '100%'
    },
    physics: {
      default: 'arcade',
      arcade: {
        gravity: { y: 200 }
      }
    },
    scene: Example
  };

  onMount(() => {
    const game = new Phaser.Game(gameConfig);
  });
</script>

<div id="game-container" style="width: 100%; height: 100vh;"></div>
