export class SharedState {
  isDialogOpen = $state(false);

  constructor() {}

  setDialogOpen(value: boolean) {
    this.isDialogOpen = value;
  }

  toggleDialogOpen() {
    this.isDialogOpen = !this.isDialogOpen;
  }
}

export const sharedState = new SharedState();
