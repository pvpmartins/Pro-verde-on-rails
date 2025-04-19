<template>
  <div
    class="h-screen px-6 py-20 md:px-12 lg:px-20 flex items-center justify-center bg-[linear-gradient(-225deg,white,white,black)] dark:bg-[linear-gradient(-225deg,black,black,white)]">
    <div class="p-12 shadow text-center lg:w-[30rem] backdrop-blur-md rounded-xl bg-[rgba(255,255,255,0.1)]">
      <div class="text-4xl font-medium mb-12 text-primary-contrast">Welcome</div>
      <InputText type="email" v-model="user.email_address"
        class="!appearance-none placeholder:!text-primary-contrast/40 !border-0 !p-4 !w-full !outline-0 !text-xl !block !mb-6 !bg-white/10 !text-primary-contrast/70 !rounded-full"
        placeholder="Email" />
      <InputText type="password" v-model="user.password"
        class="!appearance-none placeholder:!text-primary-contrast/40 !border-0 !p-4 !w-full !outline-0 !text-xl !mb-6 !bg-white/10 !text-primary-contrast/70 !rounded-full"
        placeholder="Password" />
      <button type="button" @click="login"
        class="max-w-40 w-full rounded-full appearance-none border-0 p-4 outline-0 text-xl mb-6 font-medium bg-white/30 hover:bg-white/40 active:bg-white/20 text-primary-contrast/80 cursor-pointer transition-colors duration-150">
        Sign In
      </button>
      <a class="cursor-pointer font-medium block text-center text-primary-contrast">Forgot Password?</a>
    </div>
  </div>

</template>

<script setup lang="ts">
import { router } from '@inertiajs/vue3'
import { reactive } from "vue"

const user = reactive({
  email_address: '',
  password: ""
})


const login = () => {
  router.post('/session', {
    session: {
      password: user.password,
      email_address: user.email_address
    }
  }, {
    onSuccess: e => console.log({ e }),
    onError: e => console.log({ error: e })
  })
}

</script>
