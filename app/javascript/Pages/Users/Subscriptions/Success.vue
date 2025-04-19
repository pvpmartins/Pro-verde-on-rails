<template>
  <Main>
{{ props }}    
    <Card :pt="{root: {
        class: 'w-[70%] mx-auto relative'
    }}" style="transform: translateY(50%); bottom: 50%; overflow: hidden';">
        <template #header>
            <img alt="user header" src="https://primefaces.org/cdn/primevue/images/usercard.png" />
        </template>
        <template #title> Inscrição - ID: {{ subscription.id }}</template>
        <template #subtitle>{{  subscription.id}}</template>
        <template #content>
            <p class="m-0">
                Lorem ipsum dolor sit amet, consectetur adipisicing elit. Inventore sed consequuntur error repudiandae numquam deserunt quisquam repellat libero asperiores earum nam nobis, culpa ratione quam perferendis esse, cupiditate neque
                quas!
            </p>
        </template>
        <template #footer>
            <div class="flex gap-4 mt-1">
                <Button label="Cancel" severity="secondary" outlined class="w-full" />
                <Button label="Save" class="w-full" />
            </div>
        </template>
    </Card>

  </Main>
</template>

<script setup lang="ts">
import { Plan, Product, Subscription} from '../../../types';
import { router, usePage,Link  } from '@inertiajs/vue3';
import { reactive, ref, watch } from 'vue';

const products_list = reactive<Record<string, Product>>({})

const props = defineProps<{ plan: Plan, subscription: Subscription }>();

const freqId = ref()

const page = usePage()


const freqPtBr = {monthly: 'Mensal', weekly: 'Semanal', biweekly: 'Quinzenal'}

const goToCheckout = () => {
  if(!freqId) return
  router.post(`/users/plans/${props.plan.id}/create_checkout_session`, {frequency_id: freqId.value}, {})
}

const getProduct = (id:number) => {
    for(const prop in products_list) {
        if(+prop === id) return
    }
    router.get(`${page.url}`, {product_id: id}, {
        only: ['product'],
     preserveScroll: true, 
     preserveState: true,
    onSuccess: e=> {
        const product = e.props['product'] as Product
        products_list[product?.id] = product
    }
    })
}

document.querySelectorAll('.accordion-header').forEach(btn => {
  btn.addEventListener('click', () => {
    const content = btn.nextElementSibling as HTMLButtonElement

    content.hidden = !content.hidden; // toggle visibility

    if (!content.hidden) {
      // wait a moment for DOM/layout to update
      requestAnimationFrame(() => {
        const rect = content.getBoundingClientRect();

        if (rect.bottom > window.innerHeight) {
          // Scroll so the bottom of the content is visible
          window.scrollBy({
            top: rect.bottom - window.innerHeight + 20, // 20px padding
            behavior: 'smooth'
          });
        }
      });
    }
  });
});
</script>
