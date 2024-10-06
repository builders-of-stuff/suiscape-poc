<script lang="ts">
  import Phaser from 'phaser';
  import { onMount } from 'svelte';

  import { Button, buttonVariants } from '$lib/components/ui/button/index.js';
  import * as Dialog from '$lib/components/ui/dialog/index.js';
  import { Input } from '$lib/components/ui/input/index.js';
  import { Label } from '$lib/components/ui/label/index.js';
  import * as Menubar from '$lib/components/ui/menubar';
  import Town from '$lib/scenes/town.svelte';
  import { sharedState } from '$lib/shared/shared.state.svelte';

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
        // gravity: { y: 200 }
      }
    },
    scene: [Town]
  };

  onMount(() => {
    const game = new Phaser.Game(gameConfig);
  });
</script>

<div id="game-container" style="width: 100%; height: 100vh;"></div>

<Dialog.Root
  open={sharedState.isDialogOpen}
  onOpenChange={(open) => {
    sharedState.setDialogOpen(open);
  }}
>
  <!-- <Dialog.Trigger class={buttonVariants({ variant: 'outline' })}>
    Edit Profile
  </Dialog.Trigger> -->
  <Dialog.Content class="sm:max-w-[425px]">
    <Dialog.Header>
      <Dialog.Title>Edit profile</Dialog.Title>
      <Dialog.Description>
        Make changes to your profile here. Click save when you're done.
      </Dialog.Description>
    </Dialog.Header>
    <div class="grid gap-4 py-4">
      <div class="grid grid-cols-4 items-center gap-4">
        <Label for="name" class="text-right">Name</Label>
        <Input id="name" value="Pedro Duarte" class="col-span-3" />
      </div>
      <div class="grid grid-cols-4 items-center gap-4">
        <Label for="username" class="text-right">Username</Label>
        <Input id="username" value="@peduarte" class="col-span-3" />
      </div>
    </div>
    <Dialog.Footer>
      <Button type="submit">Save changes</Button>
    </Dialog.Footer>
  </Dialog.Content>
</Dialog.Root>
