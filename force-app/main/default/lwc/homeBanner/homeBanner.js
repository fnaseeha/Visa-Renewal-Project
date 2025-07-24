import { LightningElement } from 'lwc';
import backgroundImage from '@salesforce/resourceUrl/backgroundImage';

export default class HomeBanner extends LightningElement {
  backgroundStyle = `background-image: url('${backgroundImage}'); background-size: cover; background-position: center; background-repeat: no-repeat; min-height: 300px; display: flex; align-items: center; justify-content: center;`;
}
