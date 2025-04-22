<template>
    <Admin>
        <h1 class="text-[3rem] w-fit mx-auto pb-8">Inscrições</h1>
        <div class="flex flex-col gap-4">
            <Card v-for="sub in subscriptions" >
                <template #title >
                    <div class="flex justify-between">
                    <label>Inscrição - ID: {{ sub.id }}</label>
                    <label class="absolute left-[50%] transform-[translateX(-50%)]"> Data inicial: {{ sub.start_date }}</label>
                    <Badge :value="sub.status === 'active'? 'Ativo' : 'Desativado' " size="xlarge" severity="success"></Badge>
                    </div>
                </template>
                <template #content>
                    <label v-if="!subscriptionsObj?.[sub.id]" @click="getSubscriptionDetails(sub.plan_frequency_id, sub.id)" class="w-fit mx-auto block hover:text-blue-700 cursor-pointer">Mais dados:</label>
                    <div v-if="subscriptionsObj?.[sub.id]" class="flex justify-between gap-4 h-[4rem] items-center bg-[#737373] px-3">
                        <label for=""> Plano: {{ subscriptionsObj?.[sub.id]?.name}}</label>
                        <label for="">Frequência: {{ freqPtBr[subscriptionsObj?.[sub.id]?.plan_frequency.delivery_frequency] }}</label>
                        <label for="">Preço: R${{ subscriptionsObj?.[sub.id]?.plan_frequency.price }}</label>
                    </div>
                </template> 
            </Card>
        </div>
    </Admin>
</template>

<script setup lang="ts">
import { reactive } from 'vue';
import { Subscription, SubscriptionPlan } from '../../../types';
import { router } from '@inertiajs/vue3';


const props = defineProps<{subscriptions: Subscription[]}>()

const subscriptionsObj = reactive<Record<number,SubscriptionPlan>>({})

const freqPtBr = {monthly: 'Mensal', weekly: 'Semanal', biweekly: 'Quinzenal'}

const getSubscriptionDetails = (subscriptionId: number, subId: number) => {
    router.get('/admin/subscriptions', {
        subscription_id: subscriptionId
    },
    {
        only: ['subscription'], 
        onSuccess: e=>{
            console.log({e})
           const plan = e.props['plan'] as any
           subscriptionsObj[subId] = plan
        },

        preserveScroll: true,
        preserveState: true
    })
}
</script>