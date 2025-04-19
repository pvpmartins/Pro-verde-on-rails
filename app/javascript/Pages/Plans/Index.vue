<template>
  <Main>
    <h1 class="text-[4rem] relative left-[50%] transform-[translateX(-50%)] w-fit mb-[3rem]">Nossos Planos:</h1>
    <div class="grid grid-cols-12 gap-4 justify-items-center items-baseline">
        <Card  v-for="plan in props.plans" style="width: 35rem; overflow: hidden" class="col-span-6">
    <!-- <template #header>
        <img alt="user header" src="" />
    </template> -->
    <template #title>{{ plan.name }}</template>
    <template #subtitle>
        <div v-for="frequency in plan.frequencies">
          {{freqPtBr[frequency.type]}}  - <strong>R${{frequency.price}}</strong>
        </div>
    </template>
    <template #content>
    <ul class="list-none flex flex-col gap-4 flex-1">
                    <li v-for="feature in plan.features" class="flex items-center gap-2">
                        <i class="pi pi-check-circle !text-lg text-green-500" />
                        <span class="text-surface-800 dark:text-surface-100 leading-tight"> {{ feature }}</span>
                    </li>
                </ul>
            <Accordion :multiple="true" :value="[1,2]">
    <AccordionPanel :value="plan.latest_plan_version?.id">
        <AccordionHeader >Produtos:</AccordionHeader>
        <AccordionContent >
            <Listbox :options="plan.latest_plan_version?.products" :highlight-on-select="false">
                <template #option="{ option , selected }">
                    <div class="flex flex-wrap p-1 items-center gap-4 w-full">
                        <img class="w-12 shrink-0 rounded" :src="'https://imgs.search.brave.com/MHqJNB53D5lbIGkB5udVqIIiieGsJGgBX85NgW5h-X4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NTFRY1phM20xLUwu/anBn'" :alt="option.name" />
                        <div class="flex-1 flex flex-col">
                            <span class="font-medium text-sm">{{ option.name }}</span>
                            <span :class="['text-sm', { 'text-surface-500 dark:text-surface-400': !selected, 'text-inherit': selected }]">{{ option.category }}</span>
                        </div>
                        <span  class="font-bold sm:ml-8">{{ option.quantity }}</span>
                    </div>
                </template>
            </Listbox>
        </AccordionContent>
    </AccordionPanel>
</Accordion>
    </template>
    <template #footer>
        <div class="flex gap-4 mt-1">
            <Button @click="goToPlan(plan?.id)" label="Cadastrar" class="w-full" />
        </div>
    </template>
</Card>
          </div>
  </Main>
</template>

<script setup lang="ts">
import { OrderList } from 'primevue';
import { Plan } from '../../types';
import { router } from '@inertiajs/vue3';

const props = defineProps<{ plans: Plan[] }>();

const freqPtBr = {monthly: 'Mensal', weekly: 'Semanal', biweekly: 'Quinzenal'}

const goToPlan = (id:number) => {
    router.get(`/plans/${id}/go_to_plan`)
}
</script>
